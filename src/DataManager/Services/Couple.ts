import { ApiManager } from '../Remote';

export class CoupleService {
    apiManager: ApiManager

    constructor(apiManager: ApiManager) {
        this.apiManager = apiManager;
    }

    async sendMatchRequest(targetPhoneNumber: string) {
        const body = {
            targetPhoneNumber,
        }
        return this.apiManager.post('couple/send-pairing-request', body);
    }
}
