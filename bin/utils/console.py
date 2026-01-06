from rich.console import Console
from rich.theme import Theme
from enum import StrEnum


class ConsoleType(StrEnum):
    INFO = "info"
    WARNING = "warning"
    ERROR = "error"
    SUCCESS = "success"
    NOT_FOUND = "not_found"
    HIGHLIGHT = "highlight"
    PERMISSION_DENIED = "permission_denied"
    BORDER = "border"
    DIM = "dim"
    CMD = "cmd"
    FAIL_BORDER = "fail_border"


def get_console():
    console_theme = Theme(
        {
            ConsoleType.INFO: "bold purple",
            ConsoleType.WARNING: "bold yellow",
            ConsoleType.ERROR: "bold red",
            ConsoleType.SUCCESS: "bold green",
            ConsoleType.NOT_FOUND: "dim white italic",
            ConsoleType.HIGHLIGHT: "bold cyan",
            ConsoleType.PERMISSION_DENIED: "bold yellow",
            ConsoleType.BORDER: "cyan",
            ConsoleType.DIM: "dim white",
            ConsoleType.CMD: "bold cyan",
            ConsoleType.FAIL_BORDER: "red",
        }
    )
    return Console(theme=console_theme)


def get_console_string(console_type: ConsoleType, msg: str):
    return f"[{console_type}]{msg}[/]"
