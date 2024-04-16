from src.pages.grades import Grades
#from src.settings import Settings
#from src.themes import Theme
import flet as ft


def main(page: ft.Page):
    App(page)


class App:

    def __init__(self, page: ft.Page):
        self.page = page


ft.app(target=main)