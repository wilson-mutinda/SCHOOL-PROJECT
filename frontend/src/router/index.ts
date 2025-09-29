import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/pages/HomePage.vue'
import LoginForm from '@/forms/LoginForm.vue'
import ForgotPasswordForm from '@/forms/ForgotPasswordForm.vue'
import ResetPasswordForm from '@/forms/ResetPasswordForm.vue'
import AdminDashboard from '@/pages/AdminDashboard.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: HomePage },
    { path: '/login', name: 'login', component: LoginForm },
    { path: '/forgot-password', name: 'forgot-password', component: ForgotPasswordForm },
    { path: '/reset-password', name: 'reset-password', component: ResetPasswordForm },
    { path: '/admin-dashboard', name: 'admin-dashboard', component: AdminDashboard },
  ],
});

router.beforeEach((to, from, next) => {
  const publicRoutes = ['/', '/login']

  if (publicRoutes.includes(to.path)) {
    return next();
  }
  
  next();
});

export default router
