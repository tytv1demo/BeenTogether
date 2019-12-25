import { NativeModules } from 'react-native'

const ModuleName = 'RNCommonHelper'

const BridgeModule = NativeModules[ModuleName];

export function showFlashMessage(title: string, message: string, theme: 'info' | 'success' | 'warning' = 'warning') {
    BridgeModule.showFlashMessage(title, message, theme)
}
