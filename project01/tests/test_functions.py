from project01 import Functions

def test_main():
    assert Functions.main() == "hello world"

def test_version():
    assert Functions.version() == "version 1.0"