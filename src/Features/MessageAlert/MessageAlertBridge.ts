import { NativeModules } from 'react-native';

const ModuleName = 'RNMessageAlertBridges'

const Module = NativeModules[ModuleName];

export function selectAction(id: string, type: string) {
    Module.selectAction(id, type)
}

export async function contactUs() {
    return Module.contactUs()
}

export async function reloadApp() {
    return Module.reloadApp()
}
