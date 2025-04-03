package main

import (
	"fmt"
)

func findMaxValue(numbers []int) int {
	if len(numbers) == 0 {
		panic("Массив пуст")
	}
	
	max := numbers[0]
	for _, num := range numbers {
		if num > max {
			max = num
		}
	}
	return max
}

func main() {
	// Пример использования функции
	numbers := []int{5, 2, 9, 1, 7, 6, 3}
	maxValue := findMaxValue(numbers)
	fmt.Printf("Максимальное значение в массиве %v: %d\n", numbers, maxValue)
} 