import { doc, setDoc, onSnapshot, deleteDoc, updateDoc, serverTimestamp } from 'firebase/firestore';
import { db } from './firebase';

export interface CallDoc {
  callerId: string;
  callerName: string;
  receiverId: string;
  receiverName: string;
  type: 'audio' | 'video';
  roomName: string;
  status: 'calling' | 'accepted' | 'declined' | 'ended';
  createdAt: unknown;
}

export function callDocId(uid1: string, uid2: string) {
  return [uid1, uid2].sort().join('_');
}

export async function initiateCall(
  callerId: string,
  callerName: string,
  receiverId: string,
  receiverName: string,
  type: 'audio' | 'video'
) {
  const id = callDocId(callerId, receiverId);
  const roomName = `skillswap-${id}`;
  await setDoc(doc(db, 'calls', id), {
    callerId,
    callerName,
    receiverId,
    receiverName,
    type,
    roomName,
    status: 'calling',
    createdAt: serverTimestamp(),
  } satisfies CallDoc);
  return { id, roomName };
}

export async function acceptCall(callId: string) {
  await updateDoc(doc(db, 'calls', callId), { status: 'accepted' });
}

export async function declineCall(callId: string) {
  await updateDoc(doc(db, 'calls', callId), { status: 'declined' });
}

export async function endCall(callId: string) {
  await deleteDoc(doc(db, 'calls', callId));
}

export function listenCall(callId: string, cb: (data: CallDoc | null) => void) {
  return onSnapshot(doc(db, 'calls', callId), (snap) => {
    cb(snap.exists() ? (snap.data() as CallDoc) : null);
  });
}
