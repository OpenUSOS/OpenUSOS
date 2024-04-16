from src.pages.grades import Grades
from src.settings import Settings
from src.themes import Theme
import flet as ft


def main(page: ft.Page):
    App(page)


class App:

    def __init__(self, page: ft.Page):
<<<<<<< Updated upstream
        raise NotImplementedError
=======
        self.page = page
>>>>>>> Stashed changes


ft.app(target=main)