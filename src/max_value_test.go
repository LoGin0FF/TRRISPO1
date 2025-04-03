package main

import (
	"testing"
)

func TestFindMaxValue(t *testing.T) {
	tests := []struct {
		name     string
		input    []int
		expected int
	}{
		{
			name:     "Обычный массив с положительными числами",
			input:    []int{5, 2, 9, 1, 7, 6, 3},
			expected: 9,
		},
		{
			name:     "Массив с отрицательными числами",
			input:    []int{-5, -2, -9, -1, -7, -6, -3},
			expected: -1,
		},
		{
			name:     "Массив с одинаковыми числами",
			input:    []int{5, 5, 5, 5, 5},
			expected: 5,
		},
		{
			name:     "Массив с одним элементом",
			input:    []int{42},
			expected: 42,
		},
		{
			name:     "Массив с большими числами",
			input:    []int{1000000, 999999, 1000001, 1000002},
			expected: 1000002,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := findMaxValue(tt.input)
			if result != tt.expected {
				t.Errorf("ожидалось %d, получено %d", tt.expected, result)
			}
		})
	}
}

// Тест на панику при пустом массиве
func TestFindMaxValuePanic(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Error("ожидалась паника при пустом массиве")
		}
	}()

	findMaxValue([]int{})
}

// Тест производительности
func BenchmarkFindMaxValue(b *testing.B) {
	numbers := []int{5, 2, 9, 1, 7, 6, 3, 8, 4, 10, 15, 20, 25, 30, 35, 40, 45, 50}
	
	for i := 0; i < b.N; i++ {
		findMaxValue(numbers)
	}
} 