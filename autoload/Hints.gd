extends Node


var tutorial_greeting_1 = {
	"text": "Здравствуй, вождь. Добро пожаловать в Holy Oak!",
	"position": Vector2(576.0, 320.0)
}
var tutorial_greeting_2 = {
	"text": "В этой игре ваша главная задача - защитить Священный дуб",
	"position": tutorial_greeting_1["position"]
}
var tutorial_first_tower_1 = {
	"text": "Для начала построим башню. Нажмите на пустое поле слева",
	"position": Vector2(1024.0, 128.0)
}

var tutorial_first_tower_2 = {
	"text": "Теперь нажмите 'Build', чтобы её построить",
	"position": tutorial_first_tower_1["position"]
}

var tutorial_first_tower_3 = {
	"text": "Чтобы повысить эффективность защиты, необходимо улучшить башню. Откройте меню и нажмите 'Up'",
	"position": tutorial_first_tower_1["position"]
}

var tutorial_first_tower_4 = {
	"text": "Отлично. Нажми на кнопку 'Stats', чтобы посмотреть текущие характеристики башни и юнитов",
	"position": tutorial_first_tower_1["position"]
}

var tutorial_first_tower_5 = {
	"text": "Запомни, что в случае, если нужно построить башню в другом месте, а у тебя не хватает денег, ты всегда можешь избавиться от другой, нажав 'Remove' и получив обратно 50% от стоимости (уничтожать эту башню не нужно)",
	"position": tutorial_first_tower_1["position"]
}

var tutorial_goodbye = {
	"text": "О, нет! Вы это слышите? Враг надвигается!.. Всё в ваших руках, вождь!",
	"position": tutorial_greeting_1["position"]
}

var tutorial = {
	"greeting": [tutorial_greeting_1, tutorial_greeting_2],
	"first_tower": [tutorial_first_tower_1, tutorial_first_tower_2, tutorial_first_tower_3, tutorial_first_tower_4, tutorial_first_tower_5],
	"goodbye": [tutorial_goodbye]
}
