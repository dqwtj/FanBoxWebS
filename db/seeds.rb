# coding: utf-8

i1 = Idol.create(name: "吴亦凡", weibo_name: "Mr_凡先生", weibo_uid: "3591355593", avatar_url: "http://ww4.sinaimg.cn/mw690/d60fbcc9jw8ehos8izg3cj20u00u0taq.jpg")
i2 = Idol.create(name: "鹿晗", weibo_name: "M鹿M", weibo_uid: "1537790411", avatar_url: "http://ww3.sinaimg.cn/mw690/5ba8d1cbjw8efy9zcm3iaj20u00u0gny.jpg")
i3 = Idol.create(name: "黄子韬", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")
i4 = Idol.create(name: "朴灿烈", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")
i5 = Idol.create(name: "边伯贤", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")
i6 = Idol.create(name: "吴世勋", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")
i7 = Idol.create(name: "勋鹿", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")
i8 = Idol.create(name: "灿白", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")

i1.users << User.create(name: "吴亦凡大娃", mobile: "13400000001", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i1.users << User.create(name: "吴亦凡二娃", mobile: "13400000002", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i1.users << User.create(name: "吴亦凡三娃", mobile: "13400000003", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i1.users << User.create(name: "吴亦凡四娃", mobile: "13400000004", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i2.users << User.create(name: "鹿晗大娃", mobile: "13400000005", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i2.users << User.create(name: "鹿晗二娃", mobile: "13400000006", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i2.users << User.create(name: "鹿晗三娃", mobile: "13400000007", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i2.users << User.create(name: "鹿晗四娃", mobile: "13400000008", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i3.users << User.create(name: "黄子韬大娃", mobile: "13400000009", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i3.users << User.create(name: "黄子韬二娃", mobile: "13400000000", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i3.users << User.create(name: "黄子韬三娃", mobile: "13400000011", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i3.users << User.create(name: "黄子韬四娃", mobile: "13400000012", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i4.users << User.create(name: "朴灿烈大娃", mobile: "13400000013", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i4.users << User.create(name: "朴灿烈二娃", mobile: "13400000014", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i4.users << User.create(name: "朴灿烈三娃", mobile: "13400000015", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i4.users << User.create(name: "朴灿烈四娃", mobile: "13400000016", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i5.users << User.create(name: "边伯贤大娃", mobile: "13400000017", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i5.users << User.create(name: "边伯贤二娃", mobile: "13400000018", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i5.users << User.create(name: "边伯贤三娃", mobile: "13400000019", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i5.users << User.create(name: "边伯贤四娃", mobile: "13400000020", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i6.users << User.create(name: "吴世勋大娃", mobile: "13400000021", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i6.users << User.create(name: "吴世勋二娃", mobile: "13400000022", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i6.users << User.create(name: "吴世勋三娃", mobile: "13400000023", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i6.users << User.create(name: "吴世勋四娃", mobile: "13400000024", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i7.users << User.create(name: "勋鹿大娃", mobile: "13400000025", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i7.users << User.create(name: "勋鹿二娃", mobile: "13400000026", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i7.users << User.create(name: "勋鹿三娃", mobile: "13400000027", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i7.users << User.create(name: "勋鹿四娃", mobile: "13400000028", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i8.users << User.create(name: "灿白大娃", mobile: "13400000029", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i8.users << User.create(name: "灿白二娃", mobile: "13400000030", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i8.users << User.create(name: "灿白三娃", mobile: "13400000031", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
i8.users << User.create(name: "灿白四娃", mobile: "13400000032", encrypted_password: "12345678", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1", gender: "女")
