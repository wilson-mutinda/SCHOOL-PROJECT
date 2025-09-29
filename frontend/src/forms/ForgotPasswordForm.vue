<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center px-4">
        <!-- forgot password form -->
         <div class="bg-white shadow-lg rounded-2xl p-8 w-full max-w-md relative">
            <form @submit.prevent="submitEmail" action="" method="post">
                <!-- close button -->
                 <button @click="closeForm" type="button" class="absolute right-3 top-3">
                    <img src="/close.png" alt="close" width="20">
                 </button>

                <h3 class="text-2xl font-semibold text-gray-800 mb-6 text-center">Forgot Password</h3>

                <!-- general error -->
                 <span v-if="errors.general" class="text-center text-red-600 text-sm">{{ errors.general }}</span>
                
                <!-- email -->
                 <div class="">
                    <label class="block text-sm font-medium text-gray-600 mb-2" for="email">Email</label>
                    <input @input="clearError('email')" v-model="email" placeholder="Enter your email" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:outline-none" required type="email" name="email" id="email">
                    <span v-if="errors.email" class="text-sm text-red-600 text-center">{{ errors.email }}</span>
                 </div>

                 <!-- buton -->
                  <div class="">
                    <button type="submit" class="w-full bg-blue-600 text-white font-medium py-2 rounded-lg hover:bg-blue-700 transition duration-200 mt-4">Submit</button>
                  </div>
            </form>

            <!-- back to login -->
             <p class="text-sm text-center text-gray-500 mt-6">Remebered your password? <a href="/login" class="text-blue-600 hover:underline">Login</a></p>
         </div>
    </div>

    <!-- success toast -->
     <transition name="fade">
        <div v-if="resetToken" class="fixed top-5 bg-green-600 text-white px-4 py-2 rounded-lg shadow-md">Check your email to update password</div>
     </transition>
</template>

<script>
import router from '@/router';
import api from '@/services/api';

export default {
    data() {
        return {
            email: '',
            resetToken: '',

            errors: {}
        }
    },

    methods: {

        clearError(field){
            if (this.errors[field]) {
                this.errors[field] = ''
            }
        },

        closeForm(){
            router.push('/login')
        },

        async submitEmail() {
            const payload = {
                email: this.email
            }
            try {
                const response = await api.post('forgot_password', payload);
                const token = response.data.token

                this.resetToken = token
    
                localStorage.setItem('token', this.resetToken);

                console.log('Email sent successfully!');

                this.email = ''

                // hide toast after 5 seconds
                setTimeout(() => {
                    this.resetToken = "";
                }, 5000);

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


<style>
/* Fade animation for toast */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
