<template>
    <div class="bg-gray-100 min-h-screen">
        <!-- navbar -->
         <nav class="bg-white py-4 shadow-md">
            <!-- container -->
             <div class="container mx-auto px-4 flex items-center justify-between">
                <!-- logo -->
                 <div class="flex items-center gap-2">
                    <img src="/school.png" alt="logo" width="50">
                    <span class="text-blue-600 text-3xl font-bold">SCHOOL</span>
                 </div>
                 <!-- desktop-menu -->
                  <div class="hidden md:flex gap-4 items-center">
                    <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Home</a>
                    <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">About Us</a>
                    <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Features</a>
                    <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Contact Us</a>
                    <router-link to="/login" class="bg-blue-600 px-4 py-2 rounded-md text-lg text-white font-bold">Login</router-link>
                  </div>

                  <!-- mobile-menu -->
                   <div class="block md:hidden">
                    <button @click="toggleMenu" type="button">
                        <img src="/dial-pad.png" alt="mobile" width="40">
                    </button>
                   </div>
             </div>
             <!-- mobile menu -->
              <div v-if="showMenu" class="md:hidden flex flex-col items-center gap-4">
                <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Home</a>
                <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">About Us</a>
                <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Features</a>
                <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Contact Us</a>
                <router-link to="/login" class="bg-blue-600 px-4 py-2 rounded-md text-lg text-white font-bold">Login</router-link>
              </div>
         </nav>
    </div>
</template>

<script>
export default {
    data() {
        return {
            showMenu: false
        }
    },

    methods: { 
        toggleMenu() {
            this.showMenu = !this.showMenu
        }
    }
}
</script>
