/**
 * @format
 */

import { AppRegistry } from 'react-native';
import { SettingScreen, MessageAlertView } from '@features';

export function regisFeatures() {
    AppRegistry.registerComponent('SettingScreen', () => SettingScreen)
    AppRegistry.registerComponent('MessageAlertView', () => MessageAlertView)
}
