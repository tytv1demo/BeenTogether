import React from 'react'
import { Animated, View, LayoutChangeEvent, TouchableWithoutFeedback } from 'react-native'

import { CircleIndicatorProps, CircleIndicatorState, AnimatedCircleProps } from './Types';
import { PulseCircle } from './PulseCircle'

const AnimateView = Animated.View

export class PulseCircles extends React.PureComponent<CircleIndicatorProps, CircleIndicatorState> {
    static size: number = 60
    anim: Animated.Value = new Animated.Value(0)

    animatedCircles: AnimatedCircleProps[] = []

    constructor(props: CircleIndicatorProps) {
        super(props)
        this.state = {}
    }

    componentDidMount() {
        this.animate()
    }

    //
    animate = () => {
        this.anim.setValue(0)
        Animated.timing(
            this.anim,
            {
                toValue: 10,
                useNativeDriver: true,
                duration: 1000,
                isInteraction: true,
            },
        ).start(this.collapse)
    }

    collapse = () => {
        Animated.timing(
            this.anim,
            {
                toValue: 0,
                useNativeDriver: true,
                duration: 1000,
                isInteraction: true,
            },
        ).start(this.animate)
    }

    // MARK: EVENT
    onPress = () => {
        // tslint:disable-next-line: no-unused-expression
        this.props.onPress && this.props.onPress()
    }

    onBaseCircleLayout = (e: LayoutChangeEvent) => {
        this.setState({ baseCircleLayout: e.nativeEvent.layout })
    }

    // MARK: render

    renderAnimatedCicle = () => {
        const colors: string[] = ['#ff8fa0', '#ffa7b4', '#ffcbd2', '#ffb972']
        const { baseCircleLayout } = this.state
        if (!baseCircleLayout) { return null };
        return (
            <>
                {colors.map((x, index) => {
                    return (
                        <PulseCircle
                            key={x}
                            index={index}
                            layout={baseCircleLayout}
                            anim={this.anim}
                            color={colors[index]}
                        />
                    )
                })}
            </>
        )
    }

    render() {
        return (
            <>
                <AnimateView
                    onLayout={this.onBaseCircleLayout}
                    style={[{ width: PulseCircles.size, height: PulseCircles.size }, {
                        transform: [{
                            scale: this.anim.interpolate({
                                inputRange: [0, 10],
                                outputRange: [0.7, 1],
                            }),
                        }],
                    }, {
                        borderRadius: PulseCircles.size * 0.5,
                        backgroundColor: '#ffa447',
                        alignSelf: 'center',
                        zIndex: 99,
                    }]}
                >
                    <TouchableWithoutFeedback
                        onPress={this.onPress}
                    >
                        <>
                            {this.props.children}
                        </>
                    </TouchableWithoutFeedback>
                </AnimateView>
                {this.renderAnimatedCicle()}
            </>
        )
    }
}
