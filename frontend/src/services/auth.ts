function isTokenExpired(token: string | null): boolean {
    if (!token) return true;

    const payload = JSON.parse(atob(token.split('.')[1]));
    const exp = payload['exp']
    const now = Date.now() / 1000

    const isExpired = exp < now
    return isExpired
    
}

export default isTokenExpired;