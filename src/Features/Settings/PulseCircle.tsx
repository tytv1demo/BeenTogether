import React from 'react'
import { Animated, LayoutRectangle } from 'react-native'

export interface AnimatedCircleProps {
    layout: LayoutRectangle,
    color: string,
    anim: Animated.Value,
    index: number
}

export const PulseCircle: React.FC<AnimatedCircleProps> = ({ layout, color, anim, index }) => {
    return (
        <Animated.View
            style={[
                {
                    opacity: anim.interpolate({
                        inputRange: [index * 2, 10],
                        outputRange: [0, 1],
                    }),
                    position: 'absolute',
                    backgroundColor: color,
                    borderRadius: layout.width * 0.5,
                    width: layout.width,
                    height: layout.height,
                },
                {
                    transform: [
                        {
                            translateX: layout.x,
                        },
                        {
                            translateY: layout.y,
                        },
                        {
                            scale: anim.interpolate({
                                inputRange: [index * 2, 10],
                                outputRange: [0.8, 2 - index * 0.3],
                            }),
                        },
                    ],
                },
            ]}
        />
    )
}
