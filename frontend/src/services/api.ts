import axios from "axios";

const api = axios.create({
    baseURL: "http://127.0.0.1:3000/api/v1/",
    headers: {
        "Content-Type": "application/json"
    }
});

// check whether token is expired
function isTokenExpired(token: string | null): boolean {
    if (!token) return true;
    try {
        const payload = JSON.parse(atob(token.split('.')[1]))
        const exp = payload['exp']
        const currentTime = Date.now() / 1000
    
        const isExpired = exp < currentTime
    
        return isExpired;
    } catch (error) {
        console.error("Invalid token", error);
        return true;
    }

}

// function to refreshToken
async function refreshAuthToken() {
    const refreshToken = localStorage.getItem('refresh_token');
    if (!refreshToken || isTokenExpired(refreshToken)) {
        // go to login
        localStorage.clear();
        window.location.href = '/login';
        return;
    }

    try {
        const response = await api.post(
            "refresh_token",
            {},
            {
                headers: {
                    "Authorization": `Bearer ${refreshToken}`
                }
            }
        );
    
        const newAccessToken = response.data.new_access_token
        const newRefreshToken = response.data.new_refresh_token
    
        localStorage.setItem('access_token', newAccessToken);
        localStorage.setItem('refresh_token', newRefreshToken);
    
        return newAccessToken;
    } catch (error) {
        console.error("Failed to refresh token", error);
        localStorage.clear();
        window.location.href = "/login";
    }

}

// api request
api.interceptors.request.use(
    async (config) => {
        let accessToken = localStorage.getItem('access_token')

        if (accessToken && isTokenExpired(accessToken)) {
            accessToken = await refreshAuthToken();
        }

        if (accessToken) {
            config.headers['Authorization'] = `Bearer ${accessToken}`;
        }

        return config;
    },

    (error) => {
        return Promise.reject(error)
    }
);

// api response
api.interceptors.response.use(
    (response) => response,

    async (error) => {
        // get originalRequest
        const originalRequest = error.config;

        // check for retries if not yet retried, then retry
        if (error.response && error.response.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true

            // refresh Token
            const newToken = await refreshAuthToken();

            if (newToken) {
                originalRequest.headers.Authorization = `Bearer ${newToken}`;
                return api(originalRequest);
            }
        }
        return Promise.reject(error);
    }
)

export default api;
