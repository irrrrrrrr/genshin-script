import { Fn } from './global'

export class SoundG {
  private index: number
  constructor()
  beep(n?: number, callback?: Fn | undefined): void
  init(): void
  mute(): void
  unmute(): void
}
