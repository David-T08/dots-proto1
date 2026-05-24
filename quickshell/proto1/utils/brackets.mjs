import * as Draw from "./drawing.mjs";

function revealDistance(center, lineWidth, reveal) {
  return (center - lineWidth / 2) * Math.max(0, Math.min(reveal, 1));
}

function drawCaps(ctx, x, height, lineWidth, length) {
  const padding = lineWidth / 2;

  Draw.horizontal(ctx, x, padding, length);
  Draw.horizontal(ctx, x, height - padding, length);
}

function drawSide(ctx, x, height, lineWidth, capLength) {
  Draw.vertical(ctx, x, 0, height);
  drawCaps(ctx, x, height, lineWidth, capLength);
}

export function runHeightReveal(ctx, rh, height, width, lineWidth) {
  const cx = width / 2;
  const cy = height / 2;
  const halfY = revealDistance(cy, lineWidth, rh);

  Draw.vertical(ctx, cx, cy, halfY);
  Draw.vertical(ctx, cx, cy, -halfY);
}

export function runWidthReveal(ctx, rw, height, width, lineWidth, capLength) {
  const cx = width / 2;
  const halfX = revealDistance(cx, lineWidth, rw);

  const capReveal = Math.max(0, Math.min(halfX / capLength, 1));
  const visibleCap = capLength * capReveal;

  drawSide(ctx, cx - halfX, height, lineWidth, visibleCap);
  drawSide(ctx, cx + halfX, height, lineWidth, -visibleCap);
}

export function drawFull(ctx, height, width, lineWidth, capLength) {
  const padding = lineWidth / 2;

  drawSide(ctx, padding, height, lineWidth, capLength);
  drawSide(ctx, width - padding, height, lineWidth, -capLength);
}