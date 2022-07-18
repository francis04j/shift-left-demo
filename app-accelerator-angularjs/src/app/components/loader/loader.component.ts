import { Component, OnInit } from '@angular/core';
import { timer } from 'rxjs';
import { createMonitor, monitor } from 'rxjs-stream-monitor';

@Component({
  selector: 'app-loader',
  templateUrl: './loader.component.html',
  styleUrls: ['./loader.component.css'],
})
export class LoaderComponent implements OnInit {
  monitor = createMonitor();
  value: number | null = null;

  constructor() {}

  ngOnInit(): void {
    timer(5000)
      .pipe(monitor(this.monitor))
      .subscribe(() => {
        this.value = 1;
      });
  }
}
