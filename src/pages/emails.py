import flet as ft
from ..interface import ViewInterface


class Emails(ViewInterface):

    def __init__(self, app, page: ft.Page):
        raise NotImplementedError

    def get_data(self):
        raise NotImplementedError

    def display(self):
        raise NotImplementedError

    def display_send(self):
        raise NotImplementedError
    
    def send_email(self):
        raise NotImplementedError


