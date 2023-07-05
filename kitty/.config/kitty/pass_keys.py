import re

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut


def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    return any(re.search(vim_id, p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)


def create_key_event(mods, key):
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    )
    return event.as_window_system_event()


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    if len(key) == 3 and '>' in key:
        key1, key2 = key.split('>')
        events = [
            create_key_event(mods, key1),
            create_key_event(0, key2),
        ]
    else:
        events = [create_key_event(mods, key)]

    encoded_keys = [window.encoded_key(ev) for ev in events]
    encoded_map = b''.join(encoded_keys)
    return encoded_map


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    direction = args[2]
    key_mapping = args[3]
    vim_id = args[4] if len(args) > 4 else "n?vim"
    if window is None:
        return
    if is_window_vim(window, vim_id):
        encoded_map = encode_key_mapping(window, key_mapping)
        window.write_to_child(encoded_map)
    else:
        boss.active_tab.neighboring_window(direction)
