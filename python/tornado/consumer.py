import json
import logging

from pika import URLParameters
from pika.adapters import TornadoConnection
from pika.exceptions import AMQPConnectionError

from tornado.concurrent import Future
from tornado.gen import Task
from tornado.ioloop import IOLoop


LOGGER = logging.getLogger(__name__)


class AsyncConnection:
    '''
        similar to TornadoConnection
        but every method returns a Future object
    '''
    def __init__(self, conn):
        '''
            :param TornadoConnection conn: The real connection object
        '''
        self.conn = conn

    @classmethod
    def connect(cls, url):
        f = Future()

        def on_open(conn):
            f.set_result(cls(conn))

        def on_open_error(conn, err):
            f.set_exception(AMQPConnectionError(err))

        def on_close(conn):
            LOGGER.debug('connection closed: %s', conn)

        TornadoConnection(
            URLParameters(url),
            on_open_callback=on_open,
            on_open_error_callback=on_open_error,
            on_close_callback=on_close,
        )
        return f

    def channel(self):
        f = Future()

        def on_open(channel):
            f.set_result(AsyncChannel(channel))

        def on_close(channel):
            LOGGER.debug('channel closed: %s', channel)

        _channel = self.conn.channel(on_open_callback=on_open)
        _channel.add_on_close_callback(on_close)

        return f


class AsyncChannel:
    '''
        similar to pika.channel.Channel
        but every method returns a Future object
    '''
    def __init__(self, channel):
        '''
            :param pika.channel.Channel channel: The real channel object
        '''
        self.channel = channel

    def exchange_declare(self, *argv, **kwargs):
        return Task(self.channel.exchange_declare, *argv, **kwargs)

    def queue_declare(self, *argv, **kwargs):
        return Task(self.channel.queue_declare, *argv, **kwargs)

    def queue_bind(self, *argv, **kwargs):
        return Task(self.channel.queue_bind, *argv, **kwargs)

    def data(self, queue):
        return AsyncData(self.channel, queue)


class AsyncData:
    '''
        an async data consumer which implements __aiter__ for asynchronous iterator.
    '''
    def __init__(self, channel, queue):
        '''
            :param pika.channel.Channel channel: The real channel object
            :param str queue: queue name
        '''
        self.channel = channel
        self.queue = queue

        self._future = None

        self.channel.basic_consume(
            self._on_message,
            self.queue
        )

    def _on_message(self, channel, deliver, properties, body):
        body = body.decode(properties.content_encoding)
        LOGGER.debug(
            'receive message from mq: %s',
            body
        )

        channel.basic_ack(deliver.delivery_tag)

        data = json.loads(body)
        LOGGER.debug(data)

        if self._future:
            self._future.set_result(data)
        else:
            LOGGER.error('future is None.')

    def __aiter__(self):
        return self

    async def __anext__(self):
        assert self._future is None, 'future is not None.'

        self._future = Future()
        data = await self._future
        self._future = None

        if not data:
            raise StopAsyncIteration

        return data


class Consumer:
    async def connect(self, url, exchange, exchange_type, queue, routing_key):
        connection = await AsyncConnection.connect(url)
        LOGGER.debug('connection opened')

        channel = await connection.channel()
        LOGGER.debug('channel opened')

        await channel.exchange_declare(
            exchange=exchange,
            exchange_type=exchange_type,
            durable=True,
        )
        LOGGER.debug('declare exchange success')

        await channel.queue_declare(
            queue=queue,
            durable=True,
        )
        LOGGER.debug('declare queue success')

        await channel.queue_bind(
            queue=queue,
            exchange=exchange,
            routing_key=routing_key,
        )
        LOGGER.debug('bind queue success')

        ioloop = IOLoop.current()
        ioloop.spawn_callback(self.consume, channel, queue)

    async def consume(self, channel, queue):
        async for data in channel.data(queue):
            LOGGER.debug('data: %s', data)
