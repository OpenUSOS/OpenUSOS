import sys
from pathlib import Path
import unittest
import flet as ft
from unittest.mock import patch

sys.path.append(str(Path(__file__).resolve().parents[1]))

from src.usosapi import USOSAPIConnection
from setup import App
from src.pages.emails import Emails


class TestGrades(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.connect_app()

    @classmethod
    def connect_app(cls):
        cls._app = None
        cls._page = None

    def test_get_data(self):
        with patch.object(USOSAPIConnection, 'get') as mock_get:
            mock_get.return_value = ["aa", "bb", "cc"]

            sender = Emails(self._app, self._page)
            value = sender.get_data()
            self.assertIsInstance(value,  list) # is value a list
            self.assertListEqual(value, ["aa", "bb", "cc"]) # is value the right list
            self.assertEqual(value, sender.data) # is value the same as sender.data (was data initialized properly)

    def test_display_buttons(self):
        sender = Emails(self._app, self._page)
        displayed = sender.display()
        control_list = [displayed.controls]
        while len(control_list) > 0:
            current_control = control_list.pop()
            control_list.extend(current_control.controls)
            if (isinstance(current_control, ft.ElevatedButton) or isinstance(current_control, ft.FloatingActionButton)
                or isinstance(current_control, ft.TextButton) or isinstance(current_control, ft.IconButton)
                or isinstance(current_control, ft.PopupMenuButton) or isinstance(current_control, ft.OutlinedButton)
                or isinstance(current_control, ft.CupertinoButton)):
                self.assertFalse(current_control.on_click is None)
                self.assertTrue(callable(current_control.on_click))
    
    def test_display_send(self): #???????????
        with patch.object(USOSAPIConnection, 'get') as mock_get:
            mock_get.return_value = ["aa", "bb", "cc"] 


    def test_send_email(self):
        with patch.object(USOSAPIConnection, 'get') as mock_get:
            def side_effect(*args, **kwargs):
                if args and args[0] == 'services/mailclient/send_message': #if we are sending the message
                    #test if message was send correctly, directory should be empty
                    self.assertDictEqual(original_get(*args, *kwargs), {})
                else: #else return the original get value, so that function works properly
                    return original_get(*args, **kwargs)
                
            mock_get.side_effect = side_effect  #assign the side effect.
            original_get = USOSAPIConnection.get #original get function    

            sender = Emails(self._app, self._page) 
            sender.send_email() #We are testing this


def run_tests(app: App, page: ft.Page):
    TestGrades._app = app
    TestGrades._page = page
    suite = unittest.TestLoader().loadTestsFromTestCase(TestGrades)
    unittest.TextTestRunner().run(suite)


def main(page: ft.Page):
    app = App(page)


if __name__ == "__main__":
    ft.app(target=main)