#r "..\\packages\\FSharp.Charting.0.90.10\\lib\\net40\\FSharp.Charting.dll"

open System
open System.Globalization
open FSharp.Charting

type Description =
      Transfer of string 
    | DirectDebit of string

type Transaction = { 
    id : int;
    currency : string;
    date : DateTime;
    before : decimal;
    after : decimal;
    dateAgain : DateTime;
    transaction : decimal;
    description : Description
}

let stringToDate d = System.DateTime.ParseExact(d, "yyyymmdd", null)
let stringToDecimal (s:string) = s.Replace(",", ".") |> decimal

let (|RegexContains|_|) pattern input = 
    let matches = System.Text.RegularExpressions.Regex.Matches(input, pattern)
    if matches.Count > 0 then Some input
    else None

let getDescription desc = 
    match desc with
     | RegexContains "BEA*" desc -> Transfer (desc.Substring(33))
     | _ -> DirectDebit desc

let data = System.IO.File.ReadAllLines "c:\input.TAB" 
            |> Seq.map(fun line -> line.Split [|'\t'|]) 
            |> Seq.map (fun tokens -> 
                { id = int(tokens.[0]); 
                    currency = tokens.[1];  
                    date = stringToDate tokens.[2];
                    before = stringToDecimal tokens.[3];
                    after = stringToDecimal tokens.[4];
                    dateAgain = stringToDate tokens.[5];
                    transaction = stringToDecimal tokens.[6];
                    description = getDescription tokens.[7];
                })

Chart.Point [for x in data -> x.transaction]