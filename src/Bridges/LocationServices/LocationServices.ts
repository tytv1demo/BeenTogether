import { NativeModules, EventSubscription, NativeEventEmitter } from 'react-native'
import { BehaviorSubject } from 'rxjs'

export const LocationSerivcesName = 'RNLocationServices'

const BridgeModule = NativeModules[LocationSerivcesName]

const ModuleEventEmitter = new NativeEventEmitter(BridgeModule)

export class LocationServices {

    static instance: LocationServices

    static shared() {
        if (!LocationServices.instance) {
            LocationServices.instance = new LocationServices()
        }
        return LocationServices.instance
    }

    static automaticUpdateStateChangedEvent = 'automaticUpdateStateChangedEvent'

    isAutomaticUpdateOfLocation: BehaviorSubject<boolean>

    nativeIAULSubcription: EventSubscription

    constructor() {
        this.isAutomaticUpdateOfLocation = new BehaviorSubject<boolean>(BridgeModule.isAutomaticUpdateOfLocation)
        this._onAutomaticUpdateStateChanged = this._onAutomaticUpdateStateChanged.bind(this)
        this.nativeIAULSubcription = ModuleEventEmitter.addListener(
            BridgeModule.automaticUpdateStateChangedEvent,
            this._onAutomaticUpdateStateChanged,
        )
    }

    async enableLocationUpdate(): Promise<boolean> {
        const result = await BridgeModule.enableLocationUpdate()
        return result
    }

    async disableLocationUpdate(): Promise<boolean> {
        const result = await BridgeModule.disableLocationUpdate()
        return result
    }

    _onAutomaticUpdateStateChanged(e: {value: boolean}) {
        this.isAutomaticUpdateOfLocation.next(e.value)
    }
}
