import json

import pytest

from hello_world import app


@pytest.fixture()
def cw_event():
    """ Generates CW Event"""

    return {
        "key1": "value1",
        "key2": "value2",
        "key3": "value3"
    }


def test_lambda_handler(cw_event, mocker):
    ret = app.lambda_handler(cw_event, "")
    data = json.loads(ret["body"])

    assert ret["statusCode"] == 200
    assert "message" in ret["body"]
    assert data["message"] == "hello world"
    # assert "location" in data.dict_keys()
