package main

import (
	"context"

	"github.com/wailsapp/wails/v2/pkg/runtime"
)

// App struct
type App struct {
	ctx context.Context
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

// Move the window
func (a *App) Move(x int, y int) {
	runtime.WindowSetPosition(a.ctx, x, y)
}

// Hide the window
func (a *App) Hide() {
	runtime.WindowHide(a.ctx)
}

// Show the window
func (a *App) Show() {
	runtime.WindowShow(a.ctx)
}

