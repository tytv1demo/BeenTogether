import { UserModel, CoupleModel } from '@bridges';

export interface SettingScreenState {
    userModel?: UserModel

    coupleModel?: CoupleModel

    requestPopupVisible: boolean

    isRequestBreakingUp: boolean
}

import { LayoutRectangle, StyleProp, ViewStyle, Animated } from 'react-native';

export type VAListenState = 'LISTENING' | 'PREPARE' | 'HANDLING' | 'STOP' | 'ERROR'

export interface SpeechStateIndicatorProps {

    indicatorNum: number,
    listenState: VAListenState
}

export interface SpeechStateIndicatorState {
    layout?: LayoutRectangle,
    rmsdb: number,
}

export interface IndicatorProperties {
    layout: LayoutRectangle
    color: string
}
export interface Point {
    x: number
    y: number
}

//

export interface IndicatorProps {
    rmsdb: number,
    layout: LayoutRectangle,
    size?: number
    style?: StyleProp<ViewStyle>,
    listenState: VAListenState,
    circlePoints: Point[],
    index: number
}

//

export interface CircleIndicatorProps {
    onPress?: () => void
}
export interface CircleIndicatorState {
    baseCircleLayout?: LayoutRectangle
}

export interface AnimatedCircleProps {
    layout: LayoutRectangle,
    color: string,
    anim: Animated.Value,
    index: number
}
