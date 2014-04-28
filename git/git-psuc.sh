#!/bin/bash
git push -u origin $(git rev-parse --abbrev-ref HEAD)
