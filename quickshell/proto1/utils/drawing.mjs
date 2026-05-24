export function horizontal(ctx, x, y, width) {
  ctx.moveTo(x, y)
  ctx.lineTo(x + width, y)
}

export function vertical(ctx, x, y, height) {
  ctx.moveTo(x, y)
  ctx.lineTo(x, y + height)
}