import { NativeModules } from 'react-native';

const ModuleName = 'RNMessageAlertBridges'

const Module = NativeModules[ModuleName];

export function selectAction(id: string, type: string) {
    Module.selectAction(id, type)
}
