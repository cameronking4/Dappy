class UsersModel {
    constructor(
        public token: string,
        public firstName?: string,
        public lastName?: string,
        public docId?: string,
        public contactUserName?: string[],
        public contactUserPhone?: string[],
        public searchPhone?: string[],
        public searchUserId?: string[],
        public searchUserName?: string[],
        public updatedAt?: number,
        public justPhone?: string,
        public phone?: string,
        public userName?: string,
        public userId?: string,
    ) { }
}

export = UsersModel;