 /* Copyright 2020 Josef Adamcik
  * Modification for VIA support and RGB underglow by Jens Bonk-Wiltfang
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */

//Sets up what the OLED screens display.

#ifdef OLED_ENABLE

static void render_logo(void) {
  static const char PROGMEM luv[] = {
    0x20,0x20,0x20,0x20,0x41,0x6E,0x68,0x20,0x20,0x03,0x20,0x20,0x56,0x69,0x79,0x79,0x20,0x20,0x20,0x20,0x20
  };
  static const char PROGMEM viyy[] = {
    0x20,0x20,0x20,0x61,0x6B,0x61,0x20,0x4E,0x68,0x6F,0x6B,0x5F,0x4E,0x68,0x6F,0x5F,0x39,0x34,0x20,0x20,0x20
  };

  oled_write_P(PSTR("\n"), false);
  oled_write_P(luv, false);
  oled_write_P(viyy, false);
}

static void print_status_narrow(void) {
  // Print current mode
  static const char PROGMEM logo[] = {
    0x80,0x99,0x9A,0x80,0x80,
    0x80,0xB9,0xBA,0x80,0x80,
    0x20,0x20,0x20,0x20,0x20,
    0x44,0x65,0x76,0x4F,0x70,
  };

  static const char PROGMEM line[] = {
     0x1A,0x54,0x45,0x44,0x1B
  };

  oled_write_P(PSTR("\n"), false);
  oled_write_P(logo, false);
  oled_write_P(PSTR("\n"), false);
  oled_write_P(line, false);
  oled_write_P(PSTR("\n"), false);

  // Print current layer
  oled_write_ln_P(PSTR("LAYER"), false);
  switch (get_highest_layer(layer_state)) {
      case 0:
          oled_write_P(PSTR("Qwrty\n"), false);
          break;
      case 1:
          oled_write_P(PSTR("Colmk\n"), false);
          break;
      case 2:
          oled_write_P(PSTR("Lower\n"), false);
          break;
      case 3:
          oled_write_P(PSTR("Raise\n"), false);
          break;
      default:
          oled_write_ln_P(PSTR("Undef"), false);
  }
  oled_write_P(PSTR("\n"), false);
  led_t led_usb_state = host_keyboard_led_state();
  oled_write_ln_P(PSTR("CPSLK"), led_usb_state.caps_lock);
}

oled_rotation_t oled_init_user(oled_rotation_t rotation) {
    if (is_keyboard_master()) {
        return OLED_ROTATION_270;
    }
    return rotation;
}

bool oled_task_user(void) {
    if (is_keyboard_master()) {
        print_status_narrow();
    } else {
        render_logo();
    }
    return false;
}

#endif
