from project02 import Functions2

def test_main():
    assert Functions2.main() == "hello world"

def test_version():
    assert Functions2.version() == "version 1.0"