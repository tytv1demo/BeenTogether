import axios, { AxiosInstance, AxiosResponse, AxiosRequestConfig, AxiosError } from 'axios';
import { BaseResult } from '@bridges';

export class ApiManager {
    axios: AxiosInstance

    constructor(config: AxiosRequestConfig) {
        this.axios = axios.create(config)
        this.axios.interceptors.response.use(this.onReponse, this.onError)
    }

    onReponse = (response: AxiosResponse) => {
        return response
    }

    onError = (error: AxiosError<BaseResult>) => {
        const { response } = error
        if (response) {
            return Promise.reject(new Error(response.data.message))
        }
        return Promise.reject(new Error('System error'))
    }

    setToken(token: string) {
        this.axios.defaults.headers.common.authorization = `Bearer ${token}`;
    }

    post<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<AxiosResponse<T>> {
        return this.axios.post(url, data, config)
    }

    get<T = any>(url: string, config?: AxiosRequestConfig): Promise<AxiosResponse<T>> {
        return this.axios.get(url, config)
    }
}
