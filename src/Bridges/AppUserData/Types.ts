
export interface GetUserProfileResult {
    userInfo: User
}

export interface BaseResult<T = any> {
    data: T,
    message: string
}

export type Gender = 'MALE' | 'FEMALE' | 'UNKNOW';

export interface User {
    id: number;
    name: string;
    age?: number;
    gender?: Gender;
    phoneNumber: string;
    location: UserLocation;
    coupleId: string;
}

export interface CouplePersonConfig {
    name: string;
    avatar: string;
}

export interface CoupleConfigs {
    [key: string]: CouplePersonConfig;
}

export interface Couple {
    id: string;
    configs: CoupleConfigs;
    startDate: Date | number;
    events: CoupleEvent[];
    messageThreadId: string;
}

export interface Coordinate {
    lat: number;
    lng: number;
}

export interface UserLocation {
    coordinate: Coordinate;
    from: Date | number;
}

export type AttachmentType = 'Image' | 'Video' | 'Audio';

export interface Attachment {
    url: string;
    type: AttachmentType;
}

export interface CoupleEvent {
    id: number;
    coupleId: number;
    startDate: Date;
    endDate: Date;
    location: string;
    name: string;
    description: string;
    attachments: Attachment[];
}
