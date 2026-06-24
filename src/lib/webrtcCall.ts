import {
  doc,
  collection,
  updateDoc,
  onSnapshot,
  addDoc,
  getDocs,
  deleteDoc,
} from 'firebase/firestore';
import { db } from './firebase';

const ICE_SERVERS = {
  iceServers: [
    { urls: 'stun:stun.l.google.com:19302' },
    { urls: 'stun:stun1.l.google.com:19302' },
    { urls: 'stun:stun2.l.google.com:19302' },
  ],
};

export function createPC(): RTCPeerConnection {
  return new RTCPeerConnection(ICE_SERVERS);
}

/** Call after tracks are added to pc */
export async function setupCallerSignaling(pc: RTCPeerConnection, callId: string) {
  const callRef = doc(db, 'calls', callId);

  pc.onicecandidate = (e) => {
    if (e.candidate) addDoc(collection(callRef, 'callerCandidates'), e.candidate.toJSON());
  };

  const offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  await updateDoc(callRef, { offer: { type: offer.type, sdp: offer.sdp } });

  // Listen for answer from receiver
  const unsubAnswer = onSnapshot(callRef, (snap) => {
    const data = snap.data();
    if (data?.answer && !pc.currentRemoteDescription) {
      pc.setRemoteDescription(new RTCSessionDescription(data.answer));
      unsubAnswer();
    }
  });

  // Listen for receiver ICE candidates
  onSnapshot(collection(callRef, 'receiverCandidates'), (snap) => {
    snap.docChanges().forEach((change) => {
      if (change.type === 'added') {
        pc.addIceCandidate(new RTCIceCandidate(change.doc.data()));
      }
    });
  });
}

/** Call after tracks are added to pc */
export async function setupReceiverSignaling(pc: RTCPeerConnection, callId: string) {
  const callRef = doc(db, 'calls', callId);

  pc.onicecandidate = (e) => {
    if (e.candidate) addDoc(collection(callRef, 'receiverCandidates'), e.candidate.toJSON());
  };

  // Wait for offer (may already be there)
  const offer = await new Promise<RTCSessionDescriptionInit>((resolve) => {
    const unsub = onSnapshot(callRef, (snap) => {
      const data = snap.data();
      if (data?.offer) { unsub(); resolve(data.offer); }
    });
  });

  await pc.setRemoteDescription(new RTCSessionDescription(offer));
  const answer = await pc.createAnswer();
  await pc.setLocalDescription(answer);
  await updateDoc(callRef, { answer: { type: answer.type, sdp: answer.sdp } });

  // Listen for caller ICE candidates
  onSnapshot(collection(callRef, 'callerCandidates'), (snap) => {
    snap.docChanges().forEach((change) => {
      if (change.type === 'added') {
        pc.addIceCandidate(new RTCIceCandidate(change.doc.data()));
      }
    });
  });
}

export async function cleanupCallData(callId: string) {
  const callRef = doc(db, 'calls', callId);
  const [sub1, sub2] = await Promise.all([
    getDocs(collection(callRef, 'callerCandidates')),
    getDocs(collection(callRef, 'receiverCandidates')),
  ]);
  [...sub1.docs, ...sub2.docs].forEach((d) => deleteDoc(d.ref));
}
