import {
  doc,
  collection,
  setDoc,
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
  ],
};

export async function createOffer(callId: string): Promise<RTCPeerConnection> {
  const pc = new RTCPeerConnection(ICE_SERVERS);
  const callRef = doc(db, 'calls', callId);

  // Collect caller ICE candidates
  const callerCandidates = collection(callRef, 'callerCandidates');
  pc.onicecandidate = (e) => {
    if (e.candidate) addDoc(callerCandidates, e.candidate.toJSON());
  };

  const offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  await updateDoc(callRef, { offer: { type: offer.type, sdp: offer.sdp } });

  // Listen for answer
  onSnapshot(callRef, (snap) => {
    const data = snap.data();
    if (data?.answer && !pc.currentRemoteDescription) {
      pc.setRemoteDescription(new RTCSessionDescription(data.answer));
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

  return pc;
}

export async function createAnswer(callId: string): Promise<RTCPeerConnection> {
  const pc = new RTCPeerConnection(ICE_SERVERS);
  const callRef = doc(db, 'calls', callId);

  // Collect receiver ICE candidates
  const receiverCandidates = collection(callRef, 'receiverCandidates');
  pc.onicecandidate = (e) => {
    if (e.candidate) addDoc(receiverCandidates, e.candidate.toJSON());
  };

  const snap = await new Promise<any>((resolve) => {
    const unsub = onSnapshot(callRef, (s) => {
      if (s.data()?.offer) { unsub(); resolve(s); }
    });
  });

  const offer = snap.data().offer;
  await pc.setRemoteDescription(new RTCSessionDescription(offer));
  const answer = await pc.createAnswer();
  await pc.setLocalDescription(answer);
  await updateDoc(callRef, { answer: { type: answer.type, sdp: answer.sdp } });

  // Listen for caller ICE candidates
  onSnapshot(collection(callRef, 'callerCandidates'), (s) => {
    s.docChanges().forEach((change) => {
      if (change.type === 'added') {
        pc.addIceCandidate(new RTCIceCandidate(change.doc.data()));
      }
    });
  });

  return pc;
}

export async function cleanupCallData(callId: string) {
  const callRef = doc(db, 'calls', callId);
  const sub1 = await getDocs(collection(callRef, 'callerCandidates'));
  const sub2 = await getDocs(collection(callRef, 'receiverCandidates'));
  sub1.forEach((d) => deleteDoc(d.ref));
  sub2.forEach((d) => deleteDoc(d.ref));
}
