import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import NotificationModel = require('./model/notificationModel');
import UsersModel = require('./model/UsersModel');

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.notificationCreate = functions.firestore.document('Notifications/{NotificationsId}').onCreate(async snapshot => {
    const notificationModel: NotificationModel = <NotificationModel>snapshot.data();
    notificationModel.docId = snapshot.id;

    if (notificationModel !== null && notificationModel !== undefined && notificationModel.requestUserId !== null && notificationModel.requestUserId !== undefined) {
        await db.collection('Users').doc(notificationModel.requestUserId).get().then(async (snap: any) => {
            if (!snap.empty) {
                try {
                    const objUsersModel: UsersModel = <UsersModel>snap.data();
                    const payload = {
                        'notification': {
                            'title': "Hey, " + objUsersModel.firstName + ". You got a new swap request! ",
                            'body': "Click this notifications to accept or decline the invite.",
                            'sound'  : "default",
                            // 'vibrate': "true",
                        },
                    }
                    await fcm.sendToDevice(objUsersModel.token, payload);
                }
                catch (e) {
                    console.log("Error ===========>" + e);
                }
            }
            else {
                console.log("not present");
            }
        });
    }
    else {
        console.log("Empty Obj===========>");
    }
});

exports.onUpdate = functions.firestore.document('Notifications/{NotificationsId}').onUpdate((event, context) => {
    const oldData = event.before.data();
    const newData = event.after.data();
    console.log('onUpdate started');
    if(oldData == null)
    {
        console.log('onUpdate oldData == null');
        return;
    }
        
    if(newData == null)
    {
        console.log('onUpdate newData == null');
        return;
    }

    if(oldData.isAccept == false && newData.isAccept == true)
    {
        // const requester = newData.userId;
        // const requester = newData.requestUserId;
        const requestee = newData.userId;
        const ref2 = admin.firestore().doc(`Users/${requestee}`);
    
        return ref2.get().then(function(snapshot){
        
            const user = snapshot.data();
            if(user == null) {
                console.log('User: not reached');
                return;
            }

            console.log('User Name: ' + user.firstName + " " + user.lastName);
            console.log('User Messaging Token: ' + user.token);
                
            if(user.token == null || user.token == "")
            {
                return;
            }
            const payload = {
                notification: {
                    title: 'New Swap Alert!',
                    body: 'Someone accepted your swap request. Check your Recent Swaps for more details!',
                    sound  : 'default',
                    // vibrate: 'true',
                }
            };

            admin.messaging().sendToDevice(user.token, payload).then(function(response) {
                console.log('Accept swap notification sent to: ' + newData.userId);
            }).catch(function(error)
            {
                console.log('Error: ' + error);
            });

        }).catch(function(error)
        {
            console.log('${userId} error on notification update.');
        });
    }
    return true;
});

export const searchContactrequest = functions.https.onRequest(async (req, res) => {
    const objUsersModel: UsersModel = <UsersModel>req.body;
    console.log(objUsersModel.docId);

    if (objUsersModel !== null && objUsersModel !== undefined) {
        try {
            const searchContactNumber: String[] = [];
            const searchContactName: String[] = [];
            const searchContactUserId: String[] = [];

            await db.collection('Users').get().then((snap: any) => {
                snap.forEach(async (doc: { id: any; data: () => any; }) => {
                    if (doc !== undefined && doc !== null) {
                        const userModel: UsersModel = <UsersModel>doc.data();
                        userModel.docId = doc.id;

                        if (userModel !== undefined && userModel !== null && userModel.docId !== objUsersModel.docId) {
                            if (objUsersModel !== undefined && objUsersModel !== null && objUsersModel.contactUserPhone !== undefined) {
                                objUsersModel.contactUserPhone.forEach(function (val) {
                                    const phone = val.split(' ').join('').trim();
                                    if (userModel.userName?.includes(phone)) {
                                        searchContactNumber.push(phone);
                                        searchContactName.push(userModel.firstName as string);
                                        searchContactUserId.push(userModel.docId as string);
                                    }
                                    else if (userModel.phone?.includes(phone)) {
                                        searchContactNumber.push(phone);
                                        searchContactName.push(userModel.userName as string);
                                        searchContactUserId.push(userModel.docId as string);
                                    }
                                });
                            }
                        }
                    }
                });
            });

            if (searchContactNumber.length > 0) {
                try {
                    const profileRef = db.collection('Users').doc(objUsersModel.userId as string);
                    await profileRef.update({
                        "searchPhone": searchContactNumber,
                        "searchUserName": searchContactName,
                        "searchUserId": searchContactUserId,
                    });
                    res.status(200).send({ bool: true });
                } catch (e) {
                    res.status(404).send({ bool: false, error: e });
                }
            }
        } catch (e) {
            res.status(404).send({ bool: false, error: e });
        }
    }
});


exports.usersUpdate = functions.firestore.document('Users/{UsersId}').onUpdate(async snapshot => {
    const objUsersModel: UsersModel = <UsersModel>snapshot.after.data();
    objUsersModel.docId = snapshot.after.id;
    if (objUsersModel !== null && objUsersModel !== undefined) {
        try {
            const searchContactNumber: String[] = [];
            const searchContactName: String[] = [];
            const searchContactUserId: String[] = [];

            await db.collection('Users').get().then((snap: any) => {
                snap.forEach(async (doc: { id: any; data: () => any; }) => {
                    if (doc !== undefined && doc !== null) {
                        const userModel: UsersModel = <UsersModel>doc.data();
                        userModel.docId = doc.id;

                        if (userModel !== undefined && userModel !== null && userModel.docId !== objUsersModel.docId) {
                            if (objUsersModel !== undefined && objUsersModel !== null && objUsersModel.contactUserPhone !== undefined) {
                                objUsersModel.contactUserPhone.forEach(function (val) {
                                    const phone = val.split(' ').join('').trim();
                                    if (phone === userModel.justPhone) {
                                        searchContactNumber.push(phone);
                                        searchContactName.push(userModel.userName as string);
                                        searchContactUserId.push(userModel.docId as string);
                                    }
                                    else if (phone === userModel.phone) {
                                        searchContactNumber.push(phone);
                                        searchContactName.push(userModel.userName as string);
                                        searchContactUserId.push(userModel.docId as string);
                                    }
                                });
                            }
                        }
                    }
                });
            });

            if (searchContactNumber.length > 0) {
                try {
                    const profileRef = db.collection('Users').doc(snapshot.after.id);
                    await profileRef.update({
                        "searchPhone": searchContactNumber,
                        "searchUserName": searchContactName,
                        "searchUserId": searchContactUserId
                    });
                    return;
                } catch (e) {
                    console.log("Error======>" + e);
                    return;
                }
            }
        } catch (e) {
            console.log("Collection Errro ========================>");
            return;
        }
    }
});

