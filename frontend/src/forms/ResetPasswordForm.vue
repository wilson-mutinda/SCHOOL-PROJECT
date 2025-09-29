<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded-md w-full max-w-md shadow-md relative">
            <form @submit.prevent="resetPassword" action="" method="post">

                <!-- close button -->
                 <button @click="closeForm" type="button" class="absolute right-3 top-4">
                    <img src="/close.png" alt="close" width="20">
                 </button>
                <h3 class="text-center text-xl mb-2 font-bold">Reset Password</h3>

                <!-- general error -->
                 <span v-if="errors.general" class="text-center text-red-600 text-sm">{{ errors.general }}</span>

                <!-- password -->
                 <div class="relative">
                    <label class="block text-gray-600 text-lg mb-2" for="password">Password</label>
                    <input v-model="password" class="p-2 outline-none w-full ring-1 rounded-md ring-gray-600 hover:ring-blue-600 mb-2" :type="showPassword ? 'text' : 'password'" name="password" id="password">

                    <!-- close button -->
                     <button @click="togglePassword" type="button" class="absolute right-3 top-11">
                        <img :src="showPassword ? '/hide.png' : '/show.png'" alt="hide" width="20">
                     </button>
                    <span v-if="errors.password" class="text-center text-red-600 text-sm">{{ errors.password }}</span>
                 </div>

                 <!-- password_confirmation -->
                  <div class="relative">
                    <label class="block text-gray-600 text-lg mb-2" for="password_confirmation">Password Confirmation</label>
                    <input v-model="password_confirmation" class="p-2 outline-none w-full ring-1 rounded-md ring-gray-600 hover:ring-blue-600 mb-2" :type="showPassword? 'text' : 'password'" name="password_confirmation" id="password_confirmation">

                    <!-- close button -->
                     <button @click="togglePassword" type="button" class="absolute right-3 top-11">
                        <img :src="showPassword ? '/hide.png' : '/show.png'" alt="show" width="20">
                     </button>
                    <span v-if="errors.password_confirmation" class="text-center text-red-600 text-sm">{{ errors.password_confirmation }}</span>
                  </div>

                  <!-- submit button -->
                   <div class="">
                    <button type="submit" class="w-full mt-2 mb-2 bg-blue-600 rounded-md p-2 text-white text-lg">Submit</button>
                   </div>
            </form>
        </div>
    </div>
</template>

<script>
import router from '@/router';
import api from '@/services/api'

export default {

    data() {
        return {
            token: '',
            password: '',
            password_confirmation: '',

            errors: {},

            showPassword: false
        }
    },

    methods: {

        closeForm(){
            router.push('/login')
        },

        togglePassword() {
            this.showPassword = !this.showPassword
        },

        async resetPassword() {
            this.errors = {};

            const payload = {
                token: this.token,
                password: this.password,
                password_confirmation: this.password_confirmation
            }

            try {
                const response = await api.post('reset_password', payload);
                console.log('Password reset successfully!');
    
                this.token = '',
                this.password = '',
                this.password_confirmation = ''

                router.push('/login');

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        },
    },

    mounted() {
        const urlParams = new URLSearchParams(window.location.search);
        this.token = urlParams.get('token') || localStorage.getItem('token')
    }
}
</script>
