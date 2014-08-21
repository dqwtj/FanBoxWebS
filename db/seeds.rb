# coding: utf-8
user = User.create(name: "天居", mobile: "13466593388", encrypted_password: "1234567", info: "我是一个测试用户", avatar_url: "http://tp2.sinaimg.cn/1047641505/180/5649838344/1")
card = user.cards.create(title: "有时候，前行才能看到最美的夕阳！", height: 235, image_url: "http://ww4.sinaimg.cn/bmiddle/c57974d0gw1ej57xxysiuj20c70hpdhk.jpg", favorites_count: 123, preview_image_url: "http://ww4.sinaimg.cn/bmiddle/c57974d0gw1ej57xxysiuj20c70hpdhk.jpg")
box = card.boxes.create(name: "吴亦凡")
