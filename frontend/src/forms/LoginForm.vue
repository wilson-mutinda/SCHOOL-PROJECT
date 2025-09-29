<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <!-- login form -->
         <div class="bg-white w-full max-w-md p-2 shadow-md relative">
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
                        <input v-model="email" class="p-2 outline-none ring-1 rounded-md w-full ring-gray-600 hover:ring-blue-600 mb-2" type="email" name="email" id="email">
                        <span v-if="errors.email" class="text-red-600 text-sm text-center">{{ errors.email }}</span>
                    </div>

                    <!-- password -->
                    <div class="">
                        <label class="block text-gray-600 mb-2" for="password">Password</label>
                        <input v-model="password" class="p-2 outline-none ring-1 rounded-md w-full ring-gray-600 hover:ring-blue-600 mb-2" type="password" name="password" id="password">
                        <span v-if="errors.password" class="text-red-600 text-sm text-center">{{ errors.password }}</span>
                    </div>

                    <!-- submit button -->
                    <div class="">
                        <button type="submit" class="w-full bg-blue-600 text-white rounded-md p-2 mb-2 mt-2">Login</button>
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

            errors: {}
        }
    },

    methods: {

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
                console.log('Login Successful!');
    
                this.email = '';
                this.password = '';
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
