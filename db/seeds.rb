# coding: utf-8

u1 = User.create(name: "天居", mobile: "13466593388", encrypted_password: "1234567", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1") 
u2 = User.create(name: "程铖", mobile: "18012506980", encrypted_password: "1234567", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")

c1 = u1.cards.create(title: "心塞塞的，最近不顺，画两个二胡卵子安慰自己一下", height: 468, base_url: "/test/card_1.jpg", favorites_count: 123)
c2 = u1.cards.create(title: "谁说队长不会说情话，这不就说了吗？╭(╯^╰)╮", height: 4333, base_url: "/test/card_2.jpg", favorites_count: 123)
c3 = u1.cards.create(title: "只能是师兄(第一次恶搞越苏小剧场,居然把大师兄给...回头得给他平反一下才成)", height: 4680, base_url: "/test/card_3.jpg", favorites_count: 123)
c4 = u1.cards.create(title: "看到这一口提子差点喷出去！这年头板蓝根都能成精了！？太棒了！看来海带精海瓜子精花露水精糯米滋精也不远啦！！！", height: 468, base_url: "/test/card_4.jpg", favorites_count: 123)
c5 = u2.cards.create(title: "一样的红衣，一样的黑发，甚至，毫无分差的面容，可你毕竟不是他。。。 ", height: 1961, base_url: "/test/card_5.jpg", favorites_count: 123)
c6 = u2.cards.create(title: "偶然搜到的这是什么鬼", height: 1009, base_url: "/test/card_6.jpg", favorites_count: 123)
c7 = u2.cards.create(title: "好久不见我的画报男神，竟发现如此想念。", height: 960, base_url: "/test/card_7.jpg", favorites_count: 123)
c8 = u2.cards.create(title: "Ejhehehehe……忍不住下手了。二胡卵子的迷之大眼", height: 735, base_url: "/test/card_8.jpg", favorites_count: 123)

i1 = Idol.create(name: "EXO")
i2 = Idol.create(name: "鹿晗")
i3 = Idol.create(name: "吴亦凡")
i4 = Idol.create(name: "黄子韬")
i5 = Idol.create(name: "古剑奇谭")
i6 = Idol.create(name: "李易峰")
i7 = Idol.create(name: "陈伟霆")
i8 = Idol.create(name: "二胡卵子")
i9 = Idol.create(name: "美国队长")
i10 = Idol.create(name: "钢铁侠")
i11 = Idol.create(name: "哈利波特")
i11 = Idol.create(name: "盗墓笔记")
i13 = Idol.create(name: "TFBOYS")
i14 = Idol.create(name: "王俊凯")
i15 = Idol.create(name: "王源")
i16 = Idol.create(name: "易烊千玺")
i17 = Idol.create(name: "全是猫")

b1 = Box.create(name: "大西轰")
b2 = Box.create(name: "越苏")
b3 = Box.create(name: "苏越")
b4 = Box.create(name: "铁盾")
b5 = Box.create(name: "盾铁")
b6 = Box.create(name: "瓶邪")
b7 = Box.create(name: "陈伟霆我好中意你")
b8 = Box.create(name: "心心念念李苏苏")
b9 = Box.create(name: "盗墓笔记")

Tag.create(card: c1, box: b6, hit_count: 123)

Tag.create(card: c2, box: b4, hit_count: 111)
Tag.create(card: c2, box: b5, hit_count: 23)

Tag.create(card: c3, box: b1, hit_count: 156)
Tag.create(card: c3, box: b2, hit_count: 234)
Tag.create(card: c3, box: b3, hit_count: 124)
Tag.create(card: c3, box: b7, hit_count: 234)
Tag.create(card: c3, box: b8, hit_count: 234)

Tag.create(card: c3, box: i5.box, tag_type: "idol")
Tag.create(card: c3, box: i6.box, tag_type: "idol")
Tag.create(card: c3, box: i7.box, tag_type: "idol")

Tag.create(card: c4, box: b2, hit_count: 432)
Tag.create(card: c4, box: b3, hit_count: 24)

Tag.create(card: c5, box: b2, hit_count: 65)
Tag.create(card: c5, box: b3, hit_count: 754)
Tag.create(card: c5, box: b7, hit_count: 123)
Tag.create(card: c5, box: b8, hit_count: 89)

Tag.create(card: c6, box: i9.box, hit_count: 176)
Tag.create(card: c6, box: i11.box, hit_count: 231)

Tag.create(card: c7, box: i3.box, hit_count: 79)

Tag.create(card: c8, box: i9.box, hit_count: 231)
Tag.create(card: c8, box: i8.box, hit_count: 124)

Subscribe.create(user: u1, box: b1)
Subscribe.create(user: u1, box: b2)
Subscribe.create(user: u1, box: b3)
Subscribe.create(user: u1, box: b4)
Subscribe.create(user: u2, box: b4)
Subscribe.create(user: u2, box: b4)
Subscribe.create(user: u2, box: b4)

u1.favorites << [c5, c6, c7]