<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <!-- login form -->
         <div class="bg-white w-full max-w-md p-6 shadow-md rounded-md relative">
                <form @submit.prevent="userLogin" action="" method="post">
                    <!-- close button -->
                     <button @click="closeForm" type="button" class="absolute right-2">
                        <img src="/close.png" alt="close" width="20">
                     </button>
                    <h3 class="text-center font-bold mb-2 text-xl">Login</h3>

                    <!-- general errro -->
                     <span v-if="errors.general" class="text-red-600 text-center text-sm">{{ errors.general }}</span>

                    <!-- email -->
                    <div class="">
                        <label class="block text-gray-600 mb-2" for="email">Email</label>
                        <input @input="clearError('email')" v-model="email" class="p-2 outline-none ring-1 rounded-md w-full ring-gray-600 hover:ring-blue-600 mb-2" type="email" name="email" id="email">
                        <span v-if="errors.email" class="text-red-600 text-sm text-center">{{ errors.email }}</span>
                    </div>

                    <!-- password -->
                    <div class="relative">
                        <label class="block text-gray-600 mb-2" for="password">Password</label>
                        <input @input="clearError('password')" v-model="password" class="p-2 outline-none ring-1 rounded-md w-full ring-gray-600 hover:ring-blue-600 mb-2" :type="showPassword ? 'text' : 'password'" name="password" id="password">
                        <span v-if="errors.password" class="text-red-600 text-sm text-center">{{ errors.password }}</span>

                        <!-- show button -->
                         <button @click="togglePassword" class="absolute right-3 top-10" type="button">
                            <img :src="showPassword ? '/show.png' : '/hide.png'" alt="show" width="20">
                         </button>
                    </div>

                    <!-- forgot password -->
                     <div class="text-end mt-2 mb-2">
                        <button @click="forgotPAsswordRedirect" type="button" class="text-blue-600 font-bold">Forgot Password?</button>
                     </div>

                    <!-- submit button -->
                    <div class="">
                        <button type="submit" class="w-full bg-blue-600 text-white rounded-md p-2 mb-2 mt-2">Login</button>
                    </div>

                        <!-- or -->
                        <div class="flex items-center">
                            <div class="flex flex-grow bg-gray-600 h-px"></div>
                            <span class="p-4 text-gray-600">OR</span>
                            <div class="flex flex-grow bg-gray-600 h-px"></div>
                        </div>

                        <!-- continue with google -->
                        <div class="">
                            <button @click="googleLogin" type="button" class="ring-1 w-full flex p-2 justify-center items-center gap-4 rounded-md ring-gray-600 hover:ring-blue-600 text-lg">
                                <img src="/google.png" alt="google" width="30">
                                <span>Continue with Google</span>
                            </button>
                        </div>
                    </form>
                </div>
        </div>
    </template>

    <script>
    import router from '@/router';
    import api from '@/services/api';

    export default {
        data() {
            return {
                email: '',
                password: '',

                errors: {},

                showPassword: false,
            }
        },

        mounted(){
            this.handleGoogleCallback();
        },

        methods: {

            googleLogin(){
                // google popup
                const client = google.accounts.oauth2.initTokenClient({
                    client_id: "405423890733-eci4vt2rklb6jkrnl6vj791rjmaurja8.apps.googleusercontent.com",
                    scope: "email profile",
                    callback: async (response) => {
                        try {
                            const payload = { token: response.access_token };
                            const res = await api.post("google_login", payload);
        
                            console.log("Google Login Successful:", res.data);
                            router.push('/');
                        } catch (error) {
                            console.error("Google login error", error);
                            this.errors.general = "Google Login failed. Try again.";
                        }
                    }
                });
                client.requestAccessToken();
            },

        forgotPAsswordRedirect() {
            router.push('/forgot-password')
        },

        clearError(field) {
            if (this.errors[field]) {
                this.errors[field] = ''
            }
        },

        togglePassword() {
            this.showPassword = !this.showPassword
        },

        closeForm(){
            router.push('/')
        },

        async userLogin() {
            this.errors = {};

            const payload = {
                email: this.email,
                password: this.password
            };

            try {
                const response = await api.post('user_login', payload);

                const access_token = response.data.access_token
                const refresh_token = response.data.refresh_token
                const flag = response.data.flag

                localStorage.setItem('access_token', access_token);
                localStorage.setItem('refresh_token', refresh_token);
                localStorage.setItem('flag', flag);

                console.log('Login Successful!');
    
                this.email = '';
                this.password = '';

                router.push(`/${flag}-dashboard`);

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        }
    }
}
</script>
