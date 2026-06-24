import { createBrowserRouter, Navigate } from 'react-router';
import Onboarding from './pages/Onboarding';
import Login from './pages/Login';
import Home from './pages/Home';
import AITutor from './pages/AITutor';
import SkillExchange from './pages/SkillExchange';
import PaidLesson from './pages/PaidLesson';
import Chat from './pages/Chat';
import Call from './pages/Call';
import Profile from './pages/Profile';
import Messages from './pages/Messages';
import Explore from './pages/Explore';

export const router = createBrowserRouter([
  {
    path: '/',
    Component: () => {
      window.location.href = '/onboarding';
      return null;
    },
  },
  {
    path: '/onboarding',
    Component: Onboarding,
  },
  {
    path: '/login',
    Component: Login,
  },
  {
    path: '/home',
    Component: Home,
  },
  {
    path: '/ai-tutor',
    Component: AITutor,
  },
  {
    path: '/skill-exchange',
    Component: SkillExchange,
  },
  {
    path: '/paid-lesson',
    Component: PaidLesson,
  },
  {
    path: '/chat',
    Component: Chat,
  },
  {
    path: '/call',
    Component: Call,
  },
  {
    path: '/profile',
    Component: Profile,
  },
  {
    path: '/messages',
    Component: Messages,
  },
  {
    path: '/explore',
    Component: Explore,
  },
  {
    path: '*',
    Component: () => {
      window.location.href = '/onboarding';
      return null;
    },
  },
]);