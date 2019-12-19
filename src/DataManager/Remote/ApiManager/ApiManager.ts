import axios, { AxiosInstance, AxiosResponse, AxiosRequestConfig } from 'axios';

export class ApiManager {
    axios: AxiosInstance

    constructor(config: AxiosRequestConfig) {
        this.axios = axios.create(config)
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
