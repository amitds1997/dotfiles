import os
import sys
from pathlib import Path


def _get_project_python_path():
    root_dir = Path(__file__).resolve().parent.parent
    virtual_env_python = root_dir / ".venv" / "bin" / "python3"

    return virtual_env_python


def activate_virtual_env_if_exists():
    venv_python_path = _get_project_python_path()

    if not venv_python_path.exists() or Path(sys.executable).samefile(venv_python_path):
        return

    try:
        os.execv(venv_python_path, [venv_python_path] + sys.argv)
    except OSError:
        pass
    except Exception:
        raise
