import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ColDef } from 'ag-grid-community';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-grid',
  templateUrl: './grid.component.html',
  styleUrls: ['./grid.component.css'],
})
export class GridComponent implements OnInit {
  columnDefs: ColDef[] = [
    { field: 'make', sortable: true, filter: true, checkboxSelection: true },
    { field: 'model', sortable: true, filter: true },
    { field: 'price', sortable: true, filter: true },
  ];

  rowData: Observable<any[]>;

  constructor(private http: HttpClient) {
    this.rowData = this.http.get<any[]>(
      'https://www.ag-grid.com/example-assets/row-data.json',
    );
  }

  ngOnInit(): void {
    console.info('Component initialised!');
  }
}
