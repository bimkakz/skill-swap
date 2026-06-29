import { RouterProvider } from 'react-router';
import { router } from './routes';
import { useAuth } from '../lib/AuthContext';
import { useEffect, useState } from 'react';
import { collection, query, where, onSnapshot } from 'firebase/firestore';
import { db } from '../lib/firebase';
import { IncomingCall } from './components/IncomingCall';
import { declineCall, CallDoc } from '../lib/callSignaling';

function IncomingCallListenerWrapper() {
  const { user, loading } = useAuth();
  const [incomingCall, setIncomingCall] = useState<(CallDoc & { id: string }) | null>(null);

  useEffect(() => {
    if (!user || loading) return;

    const q = query(
      collection(db, 'calls'),
      where('receiverId', '==', user.uid),
      where('status', '==', 'calling')
    );

    return onSnapshot(q, (snap) => {
      if (!snap.empty) {
        const d = snap.docs[0];
        setIncomingCall({ id: d.id, ...(d.data() as CallDoc) });
      } else {
        setIncomingCall(null);
      }
    });
  }, [user, loading]);

  if (!incomingCall) return null;

  const handleAccept = () => {
    const call = incomingCall;
    setIncomingCall(null);
    window.location.href = `/call?callId=${call.id}&type=${call.type}&userName=${encodeURIComponent(call.callerName)}`;
  };

  const handleDecline = () => {
    declineCall(incomingCall.id);
    setIncomingCall(null);
  };

  return (
    <IncomingCall
      callerName={incomingCall.callerName}
      type={incomingCall.type}
      onAccept={handleAccept}
      onDecline={handleDecline}
    />
  );
}

export default function App() {
  return (
    <>
      <RouterProvider router={router} />
      <IncomingCallListenerWrapper />
    </>
  );
}
