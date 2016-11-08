# tornado, pika, async/await 以及 asynchronous iterator

pika 是一个异步的 amqp 库, 我用它来连接 rabbitmq 并异步接收一些消息.

## callbacks

它的代码看起来是这样的(节选):

    class Consumer:
        def connect(self):
            self._connection = pika.adapters.TornadoConnection(
                pika.URLParameters(self._server_url),
                self._on_connection_open
            )

        def _on_connection_open(self, *argv):
            self._channel = self._connection.channel(
                on_open_callback=self._on_channel_open
            )

        def _on_channel_open(self, *argv):
            self._channel.exchange_declare(
                self._on_exchange_declare_ok,
                self._exchange,
                self._exchange_type,
                durable=True,
            )

        def _on_exchange_declare_ok(self, *argv):
            self._channel.queue_declare(
                self._on_queue_declare_ok,
                self._queue,
                durable=True,
            )

        def _on_queue_declare_ok(self, method_frame):
            self._channel.queue_bind(
                self._on_bind_ok,
                queue=self._queue,
                exchange=self._exchange,
                routing_key=self._routing_key,
            )

        def _on_bind_ok(self, method_frame):
            self._consumer_tag = self._channel.basic_consume(
                self._on_message,
                self._queue,
            )

        def _on_message(self, channel, deliver, properties, body):
            body = body.decode(properties.content_encoding)
            data = json.loads(body)
            # do something with data

            channel.basic_ack(deliver.delivery_tag)

大致分为 5 个步骤:

1. 连接
2. 开启 channel
3. 声明 queue
4. 绑定 queue
5. 接收消息

每一步都靠 callback 连接.
如果加上各种处理关闭以及处理错误, 那满屏都会是 callback .

## coroutine

试想一下, 如果代码变成这样:

    class Consumer:
        @coroutine
        def connect(self, url, exchange, exchange_type, queue, routing_key):
            connection = yield AsyncConnection.connect(url)
            channel = yield connection.channel()
            yield channel.exchange_declare(
                exchange=exchange,
                exchange_type=exchange_type,
                durable=True,
            )
            yield channel.queue_declare(
                queue=queue,
                durable=True,
            )
            yield channel.queue_bind(
                queue=queue,
                exchange=exchange,
                routing_key=routing_key,
            )

            channel.channel.basic_consume(
                self._on_message,
                queue,
            )

        def _on_message(self, channel, deliver, properties, body):
            body = body.decode(properties.content_encoding)
            data = json.loads(body)
            # do something with data

            channel.basic_ack(deliver.delivery_tag)

虽然 `_on_message` 依然是个 callback , 但是整体有没有清晰好多?

在 tornado 中, 我们可以靠 coroutine 来实现 AsyncConnection.
只需要在每个函数中返回一个 future 对象, 并正确处理它的 result , 就可以了.

AsyncConnection 代码如下:

    class AsyncConnection:
        '''
            similar to TornadoConnection
            but every method returns a Future object
        '''
        def __init__(self, conn):
            self.conn = conn

        @classmethod
        def connect(cls, url):
            f = Future()

            def on_open(conn):
                f.set_result(cls(conn))

            def on_open_error(conn, err):
                f.set_exception(AMQPConnectionError(err))

            TornadoConnection(
                URLParameters(url),
                on_open_callback=on_open,
                on_open_error_callback=on_open_error,
            )
            return f

        def channel(self):
            f = Future()

            def on_open(channel):
                f.set_result(AsyncChannel(channel))

            _channel = self.conn.channel(on_open_callback=on_open)

            return f


    class AsyncChannel:
        '''
            similar to pika.channel.Channel
            but every method returns a Future object
        '''
        def __init__(self, channel):
            self.channel = channel

        def exchange_declare(self, *argv, **kwargs):
            return Task(self.channel.exchange_declare, *argv, **kwargs)

        def queue_declare(self, *argv, **kwargs):
            return Task(self.channel.queue_declare, *argv, **kwargs)

        def queue_bind(self, *argv, **kwargs):
            return Task(self.channel.queue_bind, *argv, **kwargs)

## async 与 await

在 Python 3.5 中，引入了 2 个新的关键字: async 和 await.
这比使用 coroutine 和 yield, 在语义上更清晰.

connect 函数可以改写如下:

    async def connect(self, url, exchange, exchange_type, queue, routing_key):
        connection = await AsyncConnection.connect(url)
        channel = await connection.channel()
        await channel.exchange_declare(
            exchange=exchange,
            exchange_type=exchange_type,
            durable=True,
        )
        await channel.queue_declare(
            queue=queue,
            durable=True,
        )
        await channel.queue_bind(
            queue=queue,
            exchange=exchange,
            routing_key=routing_key,
        )

        channel.channel.basic_consume(
            self._on_message,
            queue,
        )

## asynchronous iterator

目前只剩下 `_on_message` 仍然是个 callback, 能不能把它也用 future 来实现呢？

不能.
因为一个 future 只能被设置 result 一次. 而 `_on_message` 会在每次有数据到达的时候被调用.

> 在 tornado 以及其它几个异步库中, 一个 future 被多次设置 result 是一个 undefined behavior

那么有没有其它办法可以解决呢?

有的. 在 Python 3.5.2 中，我们可以使用 asynchronous iterator 来实现 `_on_message` .

> 其实 Python 3.5 中就有 asynchronous iterator, 不过 Python 3.5.2 的时候, 它的使用方法发生了更改(见 pep 492). 这里我们以 Python 3.5.2 中的用法为准

调用的地方使用 async for 来异步迭代:

    async def consume(self, channel, queue):
        async for data in channel.data(queue):
            # do something with data

那么如何实现 channel.data() 呢?

    class AsyncChannel:
        # 刚才写过的那些函数省略

        def data(self, queue):
            return AsyncData(self.channel, queue)

    class AsyncData:
        '''
            an async data consumer which implements __aiter__ for asynchronous iterator.
        '''
        def __init__(self, channel, queue):
            self.channel = channel
            self.queue = queue

            self._future = None

            self.channel.basic_consume(
                self._on_message,
                self.queue
            )

        def _on_message(self, channel, deliver, properties, body):
            body = body.decode(properties.content_encoding)
            data = json.loads(body)

            if self._future:
                self._future.set_result(data)

            channel.basic_ack(deliver.delivery_tag)

        def __aiter__(self):
            return self

        async def __anext__(self):
            self._future = Future()
            data = await self._future
            self._future = None

            return data

## demo

[consumer.py](consumer.py)

## 全文完
