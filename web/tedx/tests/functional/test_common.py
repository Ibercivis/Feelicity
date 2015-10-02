from tedx.tests import *

class TestCommonController(TestController):

    def test_index(self):
        response = self.app.get(url(controller='common', action='index'))
        # Test response...
