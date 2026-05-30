@tool
class_name Parameter
extends Resource

enum Type { ## パラメータの種類
	CONVERGENCE,
	ROCKET_START,
	TORNADO,
	ICE_BALL,
	GOLD_RUSH,
	TIME_IS_MONEY,
	TIME_TO_MONEY,
}

enum CalcType { ## コスト計算式の種類
	EXPONENTIAL, ## 指数
	POLYNOMIAL, ## 多項式
	LINEAR, ## 線形
}

@export var type: Type
@export var name: String
@export var color_name: String
@export_multiline var description: String ## 全角12文字 2行まで

@export var base_cost: int
@export var factor: float
@export var calc_type: CalcType

@export var base_value: float
@export var growth_value: float

@export var max_level: int = 9999

## 現在レベルを引数として、アップグレードに必要なゴールド数を返します
func get_upgrade_cost(level: int) -> int:
	match calc_type:
		CalcType.EXPONENTIAL:
			return int(base_cost * pow(factor, level - 1))
		
		CalcType.POLYNOMIAL:
			return int(base_cost * pow(level, factor))
		
		CalcType.LINEAR:
			return int(base_cost + (factor * (level - 1)))
	
	return 0

## 現在レベルを引数として、現在のパラメータ値を返します
func get_value(level: int) -> float:
	return base_value + growth_value * (level - 1)
